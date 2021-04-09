package model

import "github.com/jinzhu/gorm"

type Clinic struct {
	gorm.Model `swaggerignore:"true"`
	Name       string `json:"name"`
	Contact    string `json:"contact"`
	Email      string `json:"email"`
	Address    string `json:"address"`
	VetID      []uint `json:"vetid"`
	//Coordinates?
	//Location?
}
