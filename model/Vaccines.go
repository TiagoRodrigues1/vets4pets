package model

import (
	"time"
	"github.com/jinzhu/gorm"
)

type Vaccines struct {
	gorm.Model `swaggerignore:"true"`
	AnimalID   int    `json:"animalID"`
	VacineName string `json:"vaccineName"`
	Date       time.Time `json:"date"`							//Data para tomar a vacina 
	Taken 	   bool `json:"taken"`								//Se tomou ou não										
	DateTaken  time.Time `json:"dateTaken"`						//Data em que tomou a vacina
	Validity   time.Time `json:"validity"`						//Data de validade da vacina (aproximado)
}
