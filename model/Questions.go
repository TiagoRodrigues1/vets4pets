package model

//import "github.com/jinzhu/gorm"

type Questions struct {
	Question string `json:"question"`
	User Users `json:"user"`
}