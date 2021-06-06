package model

import "github.com/jinzhu/gorm"

type Animal struct {
	gorm.Model `swaggerignore:"true"`
	Name string `json:"name"`
	AnimalType string `json:"animaltype"`
	Race string `json:"race"`
	ProfilePicture string `json:"profilePicture"`
	Picture string `json:"picture"`
	UserID uint `gorm:"TYPE:integer REFERENCES users"`
}
