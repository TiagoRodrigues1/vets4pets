package model

//import "github.com/jinzhu/gorm"

type Appointment struct {
	ShowedUp bool `json:"showedUp"`
	Animal Animal `json:"animal"`
	//falta a data
}
