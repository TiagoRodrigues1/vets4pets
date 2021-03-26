package model

import "github.com/jinzhu/gorm"

type Animal struct {
	gorm.Model `swaggerignore:"true"`
	Name string `json:"name"`
	AninalType string `json:"animalType"`
	Race string `json:"race"`
	Picture []byte `json:"picture"`
	VaccinationCard []byte	`json:"vaccinationCard"`
	//OwnerId Users `json:"owner"`
}
