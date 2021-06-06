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
	Birth string `json:"birth"`
	Email string `json:"email"`
	PhoneNumber string `json:"phonenumber"`
	Attachement1 string `json:"attachement1"`
	Attachement2 string `json:"attachement2"`
	Attachement3 string`json:"attachement3"`
	Attachement4 string `json:"attachement4"`
	Username string `json:"username"`
}
