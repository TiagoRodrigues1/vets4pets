package model

import (
	"time"
	"github.com/jinzhu/gorm"
)

type Vaccines struct {
	gorm.Model `swaggerignore:"true"`
	AnimalID   uint        `gorm:"TYPE:integer REFERENCES animals"`	
	VacineName string `json:"vacineName"`
	Date       time.Time `json:"date"`							//Data para tomar a vacina 
	Taken 	   bool `json:"taken"`									//Se tomou ou não										
	DateTaken  time.Time `json:"dateTaken"`							//Data em que tomou a vacina
	Validity   time.Time `json:"Validity"`						//Data de validade da vacina (aproximado)
}
