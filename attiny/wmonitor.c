
/*检测到外电掉电，就检查呼吸灯，如果呼吸灯失效，表示无线模块停止，这时候继续等外电稳定上电，5s后，然后发3s的低脉冲，重启无线模块。*/
/*平时检查呼吸灯，如果无线模块死机，切断主电源5s，再上电，3s后，重启无线模块。等待60秒，才能再测呼吸灯。*/

#define F_CPU	9600000UL
#include <avr/io.h>
/*#include <avr/iotn13a.h>*/
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/sfr_defs.h>
#include <util/delay.h>

#define set(a,b)		a|=(1<<b)
#define setn(a,b,c)		a|=(c<<b)
#define clr(a,b)		a&=~(1<<b)
#define tst(a,b)		a&(1<<b)

/*#define WirelessPin 3*/
/*#define MainSupplyPin 4*/

/*#define Woff PORTB&=~(1<<3)*/
/*#define Won PORTB|=(1<<3)*/
/*#define Moff PORTB&=~(1<<4)*/
/*#define Mon PORTB|=(1<<4)*/

/*all in TIM0_COMPA_vect*/
#define Woff	clr(PORTB,3)
#define Won		set(PORTB,3)
#define Moff	clr(PORTB,4)
#define Mon		set(PORTB,4)


/*上电/无线模块启动后，等待60秒，才检测呼吸灯。*/
unsigned char waitWireless;
#define waitS 60
/*计数到5次，表示呼吸灯失效。*/
unsigned char cntWoff=0;
#define cntS 5

/*主电源掉电计时间，大于5秒认为真掉电？*/
/*0为不动作，没掉电。1为启动，计数到10为5秒*/
unsigned char cntMoff=0;

unsigned char loop;
/*unsigned char FPoweroff;*/

//------------------------------------------
void startcomp(void){
	clr(ACSR,ACIE);		//关cmp中断
	set(ACSR,ACD);		//模拟器断电
	set(DIDR0,AIN1D);	//AIN1的数字输入缓冲禁用
	clr(ADCSRB,ACME);	//负极选 AIN1
	//PB1 (MISO/AIN1/OC0B/INT0/PCINT1)
	set(ACSR,ACBG);		//正极选基准源1.1V
/*    clr(ACSR,ACIS1);*/
/*    clr(ACSR,ACIS0);*/
	//ACIS1 ACIS0 比较器输出变化即可触发中断。
	//直接读取ACO，获得比较结果。
	clr(ACSR,ACD);		//模拟器上电
	set(ACSR,ACIE);		//开cmp中断

}

// 中断向量名在 /usr/lib/avr/include/avr/iotn13a.h
ISR(ANA_COMP_vect){
	//6 0x0005 ANA_COMP 模拟比较器
	if(tst(ACSR,ACO)){			//主电源掉电
		waitWireless=0;
		cntMoff=1;		//启动掉电计数
/*        cntWoff=0;*/
	}else{			//主电源上电
		cntMoff=0;
	}
/*    else Mon;*/
/*    loop++; if(loop&1){Mon;}else{Moff;}*/
/*    FPoweroff=tst(ACSR,ACO);*/
}
//------------------------------------------
void starttimer(void){
	TCCR0A=0b01000010;
	//COM0A1 COM0A0 COM0B1 COM0B0 – – WGM01 WGM00
	//A通道匹配时翻转OC0A引脚，B通道禁止，CTC模式
	//PB0 (MOSI/AIN0/OC0A/PCINT0)
/*    OCR0A=125;*/
	//选择128k主频时，记125次为1秒，OC中断一次
	OCR0A=147;
	//选择150k主频时，150k/1024=146.5次为1秒，OC中断一次
	set(TIMSK0,OCIE0A);
	//开启输出比较的A通道中断
	//– – – – OCIE0B OCIE0A TOIE0 –
	TCCR0B=0b00000101;
	//FOC0A FOC0B – – WGM02 CS02 CS01 CS00
	//选择1024分频，并启动
}

ISR(TIM0_COMPA_vect){		///秒中断
	//7 0x0006 TIM0_COMPA 定时器 / 计数器比较匹配 A
	if(cntMoff>0 && cntMoff<10){cntMoff++;}
/*    if(FPoweroff){*/
		//外电掉电后，检查呼吸灯干嘛 ??????????
/*    }*/
	if(cntWoff>cntS){		///无线模块死机
		if(cntMoff==0){		//主电源有电
			///关闭中断，并清除标志！！！
			cli();
			//切断主电源5s，再上电，3s后，重启无线模块。
			Moff;
			_delay_ms(3000);
/*            主电源不需要5秒的延时*/
			Mon; Woff;
			_delay_ms(3000);
			Won;
			///开中断。
			waitWireless=waitS; cntWoff=0;
		}
	}
	else{
		if(waitWireless){waitWireless--;}	//不监测
		else cntWoff++;
	}
}
//------------------------------------------
void startint(void){
	//PB2 (SCK/ADC1/T0/PCINT2)
	PCMSK=0b100;
	set(GIMSK,PCIE);
/*
	//PB1 (MISO/AIN1/OC0B/INT0/PCINT1)
	//注意,通过电平方式触发中断,从而将 MCU 从掉电模式唤醒时,要保证电平保持一定的时间。若电平在启动完成前结束, MCU 被唤醒,但不会产生中断。启动时间由 P20“ 系统时钟及时钟选项 ” 所示的 SUT 与 CKSEL 熔丝位定义。
	MCUCR=1;
	//– PUD SE SM1 SM0 – ISC01 ISC00
	//ISC01 ISC00 0 1 INT0 引脚上任意的逻辑电平变化都将引发中断
	set(GIMSK.INT0);
	//– INT0 PCIE – – – – –
	//启动INT0，不启动PCINT5..0。
*/
}

ISR(PCINT0_vect){
	//3 0x0002 PCINT0 外部中断请求 1
	cntWoff=0;
}

//------------------------------------------
void startwdt(void){
	clr(MCUSR,WDRF); clr(WDTCR,WDE);	//禁止复位使能
	WDTCR = 0b01000110;		//中断使能 1.0s
/*    WDTCR = 0b00100001;		//中断禁止 8.0s*/
	//WDTIF WDTIE **WDP3** WDCE WDE WDP2 WDP1 WDP0
	//WDTON 熔丝位
	loop=0;
}

ISR(WDT_vect){
	//9 0x0008 WDT 看门狗暂停
	/*
	__disable_interrupt();
	__watchdog_reset();
	// 清除 MCUSR 寄存器中 WDRF
	MCUSR &= ~(1<<WDRF);
	// 在 WDCE 与 WDE 中写逻辑 1
	// 保持旧预分频器设置防止无意暂停
	WDTCR |= (1<<WDCE) | (1<<WDE);
	// 关闭 WDT
	WDTCR = 0x00;
	__enable_interrupt();
	*/
/*    loop++; if(loop&1){Mon;}else{Moff;}*/
}
//------------------------------------------
/*void Reset_Wireless(void){	///重启无线模块*/
/*    Woff;*/
/*    cntWoff=0;*/
/*    waitWireless=waitS;*/
/*}*/

//BODLEVEL [1..0] 熔丝位 01 2.7V
//CKDIV8 要改1，不编程。
//CKSEL[1:0]=11，改，选128k主频。
/*CKSEL1..0  01 4.8 MHz*/
/*SUT1..0 10 6 CK 14CK + 64 ms 电源缓慢上升*/

//时钟方案：Fuse全不动。修改 时钟预分频寄存器- CLKPR

//MCUSR 状态寄存器提供了有关引起 MCU 复位的复位源的信息。
//– – – – WDRF BORF EXTRF PORF
int main(void)
{
/*    cli();*/
	//fuse4.8M
	CLKPR=0x80;		//CKDIV8熔丝位决定CLKPS位的初始值，不管。
	CLKPR=0b0101;	//4.8M用32分配，主频150K。
/*    CLKPR=0b1000;	//4.8M用256分配，主频300K。*/
	//初始化端口
	DDRB=	0b00011001;
	PORTB=	0b11111000;		//未用引脚具有确定电平的方法是使能内部上拉电阻
	PINB=	0xff;
/*    WDTCR=0;		//关闭 WDT。*/
	//0 1 1 0 128K (131072) 周期 1.0 s
	//WDT的中断，其实也可以作RTC。
	waitWireless=waitS; cntWoff=0;
/*    startwdt();*/
	starttimer();	///启动秒中断
	startint();
	startcomp();
/*    FPoweroff=0;*/
	cntMoff=0;
/*    Mon;*/

	set_sleep_mode(SLEEP_MODE_IDLE);
	//CPU 停止运行,而模拟比较器、 ADC、定时器 / 计数器、看门狗和中断系统继续工作。这个休眠模式只停止了 clk CPU 和 clk FLASH ,其他时钟则继续工作。
/*    cli();*/
	while(1){sleep_enable();sei();}
	return 0;

}
