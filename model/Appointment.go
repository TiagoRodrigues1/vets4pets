package model

import ("github.com/jinzhu/gorm"
		"time")

type Appointment struct {
	gorm.Model `swaggerignore:"true"`
	ShowedUp bool `json:"showedUp"`
	AnimalID uint `gorm:"TYPE:integer REFERENCES animals"`
	Date time.Time `json:"date"`
	VetID uint `gorm:"TYPE:integer REFERENCES users"`
}	
