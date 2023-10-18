#include <SPI.h>


/*
                     Mighty 1284p    
                      +---\/---+
           (D 0) PB0 1|        |40 PA0 (AI 0 / D24)
           (D 1) PB1 2|        |39 PA1 (AI 1 / D25)
      INT2 (D 2) PB2 3|        |38 PA2 (AI 2 / D26)
       PWM (D 3) PB3 4|        |37 PA3 (AI 3 / D27)
    PWM/SS (D 4) PB4 5|        |36 PA4 (AI 4 / D28)
      MOSI (D 5) PB5 6|        |35 PA5 (AI 5 / D29)
  PWM/MISO (D 6) PB6 7|        |34 PA6 (AI 6 / D30)
   PWM/SCK (D 7) PB7 8|        |33 PA7 (AI 7 / D31)
                 RST 9|        |32 AREF
                VCC 10|        |31 GND
                GND 11|        |30 AVCC
              XTAL2 12|        |29 PC7 (D 23)
              XTAL1 13|        |28 PC6 (D 22)
      RX0 (D 8) PD0 14|        |27 PC5 (D 21) TDI
      TX0 (D 9) PD1 15|        |26 PC4 (D 20) TDO
RX1/INT0 (D 10) PD2 16|        |25 PC3 (D 19) TMS
TX1/INT1 (D 11) PD3 17|        |24 PC2 (D 18) TCK
     PWM (D 12) PD4 18|        |23 PC1 (D 17) SDA
     PWM (D 13) PD5 19|        |22 PC0 (D 16) SCL
     PWM (D 14) PD6 20|        |21 PD7 (D 15) PWM
                      +--------+
*/
/***************************************************************************************/
/*                                                                                     */
/* Program:         LTC1865_ADC_Example(adapted for arduino)                           */
/* Original Author: Chris Mabey                                                        */
/* Date:            November 2016                                                      */
/* Target Platform:Arduino                                                             */
/* Description:     External LTC1865 16-bit ADC example                                */
/* Version:         1v0                                                                */
/*                                                                                     */
/*        LTC1865 Datasheet: http://cds.linear.com/docs/en/datasheet/18645fb.pdf       */
/*                                                                                     */
/***************************************************************************************/

//#define SS          4    // PB4
//#define MOSI        5    // PB5
//#define MISO        6    // PB6
#define TRACE       0    // PB0
#define RESET       22   // PC6


/* The LTC1864 ADC has two input channels */
#define ADC_CHANNEL_0 0
#define ADC_CHANNEL_1 1

/*SPI Pin definitions*/
#define SPI_CS    18 // PC2  

/* The LTC1864 conversion cycle begins with the rising edge of CONV.  */
/* After a period equal to tCONV, the conversion is finished.         */
/* The maximum conversion time is 3.2uS, so wait for 4uS              */
/* accepts an integer value.                                          */
#define ADC_CONVERSION_TIME 40


/***********************************************************/
/*                                                         */
/* Read_External_ADC / SendCommand                         */
/*                                                         */
/* Function: Read the latest value from the specified      */
/*           channel of the external LTC1865 ADC.          */
/*                                                         */
/* Input Parameters:                                       */
/* unsigned char: the ADC channel                          */
/*                                                         */
/* Output Parameters:                                      */
/* unsigned int: the ADC value (range 0 to 65535)          */
/*                                                         */
/***********************************************************/
uint16_t Read_External_ADC()
{
  uint16_t adcVal;
  /* The LTC1865 conversion cycle begins with the rising edge of CONV */
  digitalWrite(SPI_CS, HIGH);

  /* Wait for the conversion to complete */
  delayMicroseconds(ADC_CONVERSION_TIME);

  /* Enable the Serial Data Out to allow the data to be shifted out by taking CONV low */
  digitalWrite(SPI_CS, LOW);

  /* Send command and read previous selected ADC channel value, whilst */
  /* telling the ADC the next conversion is for the new channel        */
  uint16_t transmitVal = (0x8000);
  adcVal = SPI.transfer16(transmitVal);

  return (adcVal); /* Return the 16-bit ADC value */
}

void setup() {
  Serial.begin(115200);
  
  Serial.println("Cvak...");
  //Define SPI Chip Select pin
  pinMode(SPI_CS, OUTPUT);
  pinMode(RESET, OUTPUT);
  digitalWrite(SPI_CS, LOW); /* Deselect the ADC by setting chip select low */
  digitalWrite(RESET, LOW); /* Deselect the ADC by setting chip select low */
 
  //Initialise SPI interface
  //SPI clock speed:10MHz, Data Shift:MSB First, Data Clock Idle: SPI_MODE1
  SPI.beginTransaction(SPISettings(1000000, MSBFIRST, SPI_MODE1));
  SPI.begin();
  
  Serial.println("Hmmm...");

  /* Perform a dummy read to initialise the ADC conversion channel to ADC_CHANNEL_0 */
  Read_External_ADC();

  Serial.println("LTC1865 External ADC Example");

}

uint16_t value = 0;
uint16_t transmitVal = (0x8000);

void loop() {
  //clock_prescale_set(clock_div_16);

  while(!digitalRead(TRACE));
  delayMicroseconds(4);
  //while(digitalRead(TRACE));
  digitalWrite(RESET, HIGH);
  uint16_t adcVal = SPI.transfer16(transmitVal);


/*  
  //pinMode(TRACE, OUTPUT);
  //delayMicroseconds(20);
  //digitalWrite(SPI_CS, HIGH);
  //digitalWrite(SPI_CS, LOW);
  
  //Serial.println(Read_External_ADC());
  //uint16_t value = Read_External_ADC();
  pinMode(TRACE, OUTPUT);
  digitalWrite(TRACE, HIGH);
  delayMicroseconds(20);             // guaranteed reset
  pinMode(TRACE, INPUT);

  if(value>18500) Serial.println(value>>6);
*/

  //clock_prescale_set(clock_div_1);
  if(adcVal>18550) Serial.println(adcVal);
  //clock_prescale_set(clock_div_16);
  digitalWrite(RESET, LOW);
  //Serial.println(adcVal);
  //delay(500); /* 0.5s arbitrary wait*/
}
