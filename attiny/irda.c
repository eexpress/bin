/*ATtiny13*/
/*缺省9.6MHz*/
#include <avr/power.h>
#include <avr/eeprom.h>
#define set(a,b)		a|=(1<<b)
#define setn(a,b,c)		a|=(c<<b)
#define clr(a,b)		a&=~(1<<b)
#define tst(a,b)		a&(1<<b)
/*unsigned char buffer[40];*/
unsigned char ir_cnt=0;
unsigned long ir_data=0;

//600/64=9.375kHz.
//13.5ms: 600/64*13.5=126.5
//1.13ms: 600/64*1.13=10.59
//2.25ms: 600/64*2.25=21
#define C15MS 140
#define C12MS 112
#define C1MS7 16
#define LEDon		clr(PORTB,4)
#define LEDoff		set(PORTB,4)
uint8_t EEMEM eeircode[2];

ISR(INT1_vect){
	unsigned char i;
	//普通模式 (TCCR0B,WGM02,TCCR0A,WGM01:0 = 0)
	if(ir_cnt==0){
		power_timer0_enable();
		TCNT0=0; TCCR0B=0b11;		//0 1 1 clk I/O /64
		ir_cnt=1; return;}
	i=TCNT0; TCNT0=0;

	if(i>C15MS){ir_stop(); return;}
	if(i>C12MS){ir_cnt=2; ir_data=0; return;}
	if(ir_cnt<2)return;
	ir_data=ir_data<<1; if(i>C1MS7) ir_data++; ir_cnt++;
	if(ir_cnt<=33)return;
	ir_stop();
	//fetch data here.
	//设备，反码，数据，反码
/*    eeprom_read_byte(&eeircode[0])*/
}

ISR(TIMER0_OVF_vect){ ir_stop(); }

void ir_stop(void){ ir_cnt=0; TCCR0B=0x00; power_timer0_disable(); }

int main(void)
{
	clock_prescale_set(4);	//16分频,600k主频，9.6/16=.600, CLKPCE
	power_adc_disable();
/*    power_timer0_disable();*/
	ir_stop();

	//省电：
	//内部电压基准源
	set(ACSR,ACD);		//模拟器断电
	//熔丝位 BODLEVEL[1..0]不编程
	//WDTON 熔丝位=0
	clr(WDTCR,WDE);clr(WDTCR,WDTIE);

	clr(DDRB,PB1);	//INT0
	set(DDRB,PB4);	//LED翻转
	PORTB=0;

	set(TIMSK0,TOIE0);		//T0溢出中断
	set(MCUCR,ISC01); set(GIMSK,INT0);		//INT0下降沿中断

	cli();
	while(1){
		if(ir_cnt==0)set_sleep_mode(SLEEP_MODE_PWR_DOWN);
		else set_sleep_mode(SLEEP_MODE_IDLE);
		sleep_mode();
	}
}
