/*无线模块启动后，需要60秒，才可以确定呼吸灯有效。*/
/*上电后，等待60秒，才检测呼吸灯。*/
/*AD检测到外电掉电，就检查呼吸灯，如果呼吸灯失效，表示无线模块停止，这时候继续等外电稳定上电，5s后，然后发3s的低脉冲，重启无线模块。*/
/*平时检查呼吸灯，如果无线模块死机，切断主电源5s，再上电，3s后，重启无线模块。等待60秒，才能再测呼吸灯。*/

#define F_CPU	8000000UL

#define set(a,b)		a|=(1<<b)
#define setn(a,b,c)		a|=(c<<b)
#define clr(a,b)		a&=~(1<<b)

#define freeW set(PORTB,1)
#define resetW clr(PORTB,1)

#define WirelessPin 1
#define MainSupply 2

unsigned char cntW;
unsigned char cntDelay;

int main(void)
{
	//初始化端口
	DDRB=0b10111111;
	DDRB=0x3f;
	cntDelay=60; cntW=0;
	///启动秒中断

	set_sleep_mode(SLEEP_MODE_PWR_DOWN);
	cli();
	while(1){sleep_enable();sei();}
	return 0;

}

/*void T2mode(char i)*/
/*{*/
/*    OCR1A=0;TCCR1A=0;TCCR1B=0;TCCR2=0;*/
/*    set(TIMSK,OCIE2);*/
/*}*/

ISR(TIMER0_OVF_vect){	///秒中断
	if(cntDelay){cntDelay--;}else{
		///监测呼吸灯数据
	}

	cntW--;
	if(!cntW){set(PORTB,WirelessPin);cntDelay=60;}
}

void Reset_Wireless(void){	///重启无线模块
	clr(PORTB,WirelessPin);
	cntW=3;
}
