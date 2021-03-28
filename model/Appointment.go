package model

import "github.com/jinzhu/gorm"
	

type Appointment struct {
	gorm.Model `swaggerignore:"true"`
	ShowedUp bool `json:"showedUp"`
	AnimalID uint `gorm:"TYPE:integer REFERENCES animals"`
	Day int `json:"day"`
	Month int `json:"month"`
	Year int `json:"year"`
	Hour int `json:"hour"`
	Minutes int `json:"minutes"`
	
}
