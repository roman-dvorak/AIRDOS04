#define LED         23   // PC7
 
static bool toggle = false;
static bool blink = false;

// Timer 1 interrupt service routine (ISR)
ISR(TIMER1_COMPA_vect)
{
  blink = true;
  
  //digitalWrite(LED, toggle);
  toggle = !toggle;
}
 
void setup()
{
  pinMode(LED, OUTPUT); 
  digitalWrite(LED, HIGH);
  delay(100);
  digitalWrite(LED, LOW);
  
  Serial.begin(115200); // Serial connection to print samples
   
  cli(); // disable interrupts during setup
 
  // Configure Timer 1 interrupt
  // F_clock = 16e6 Hz, prescaler = 1024, Fs = 0.25 Hz
  TCCR1A = 0;
  //TCCR1B = 1<<WGM12 | 0<<CS12 | 1<<CS11 | 1<<CS10;
  TCCR1B = 1<<WGM12 | 1<<CS12 | 0<<CS11 | 1<<CS10;
  // OCR1A = ((F_clock / prescaler) / Fs) - 1 = 2499
  OCR1A = 62500;//2499;       // Set sampling frequency Fs = 100 Hz
  TCNT1 = 0;          // reset Timer 1 counter
  TIMSK1 = 1<<OCIE1A; // Enable Timer 1 interrupt
 
  sei(); // re-enable interrupts
}
 
void loop()
{
  if (blink)
  {
    digitalWrite(LED, HIGH);
    delay(100);
    digitalWrite(LED, LOW);   
    blink = false;
  }
}

/*

// These define's must be placed at the beginning before #include "TimerInterrupt.h"
// _TIMERINTERRUPT_LOGLEVEL_ from 0 to 4
// Don't define _TIMERINTERRUPT_LOGLEVEL_ > 0. Only for special ISR debugging only. Can hang the system.
#define TIMER_INTERRUPT_DEBUG         0
#define _TIMERINTERRUPT_LOGLEVEL_     0

#define USE_TIMER_1     false

// Select just 1 TIMER to be true
#define USE_TIMER_2     false
// TIMER_3 Only valid for ATmega1284 and ATmega324PB (not ready in core yet)
#define USE_TIMER_3     true
// TIMER_4 Only valid for ATmega324PB, not ready in core yet
#define USE_TIMER_4     false


// To be included only in main(), .ino with setup() to avoid `Multiple Definitions` Linker Error
#include "ATmega_TimerInterrupt.h"

#define LED     23


void TimerHandler1()
{
  static bool toggle1 = false;

  
  digitalWrite(LED, toggle1);
  toggle1 = !toggle1;
}

void setup()
{
  pinMode(LED, OUTPUT);

  ITimer3.init();

  ITimer3.attachInterruptInterval(1000, TimerHandler1);
}

void loop()
{
}
*/
