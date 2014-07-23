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
//	Internal 128 kHz Oscillator, CKSEL[1:0]=11, fuses unprogrammed. SUT[1:0]=00?
//	The device is shipped with CKSEL = “10”, SUT = “10”, and CKDIV8 programmed.
//	If CKDIV8 Fuse is unprogrammed, the CLKPS bits will be reset to “0000”.Clock Division Factor=1.
	///启动秒中断
	///CSn[2:0]=6 T0 Prescaler /1024
	///COM0A[1:0] 0 1 Toggle OC0A on Compare Match
	///WGM02 = 1: Toggle OC0A on Compare Match.
	//Figure 11-11. Timer/Counter Timing Diagram, Clear Timer on Compare Match mode, with Prescaler (f clk_I/O /8)
	///CTC Mode WGM0[2:0] = 2, OCR0A=TOP 128?
	//TIFR0:OCF0A 中断 TIM0_COMPA

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
