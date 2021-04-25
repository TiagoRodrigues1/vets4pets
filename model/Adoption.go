package model

import "github.com/jinzhu/gorm"

type Adoption struct {
	gorm.Model `swaggerignore:"true"`
	Name string `json:"name"`
	AnimalType string `json:"animaltype"`
	Race string `json:"race"`
	UserID uint `gorm:"TYPE:integer REFERENCES users"`
	Text string `json:"text"`
	Adopted bool `json:"adopted"`
	City string `json:"city"`
	Birth int `json:"birth"`
	Email string `json:"email"`
	Phonenumber string `json:"phonenumber"`
	Attachement1 []byte `json:"attachement"`
	Attachement2 []byte `json:"attachement"`
	Attachement3 []byte`json:"attachement"`
	Attachement4 []byte `json:"attachement"`	
}
