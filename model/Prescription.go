package model

import (
	"time"
	"github.com/jinzhu/gorm"
)

type Prescription struct {
	gorm.Model 			  `swaggerignore:"true"`
	Weight     	float32   `json:"weight"`	
	Price      	float32   `json:"price"`
	Medication 	string    `json:"medication"`
	Date       	time.Time `json:"date"`
	AnimalID   	uint      `json:animalID`
	Description string	  `json:description`
	PetName		string	  `json:petname`
	VetID 		uint	  `json:vetID`
}
