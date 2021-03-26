package model

//import "github.com/jinzhu/gorm"

type Attachements struct {
	Attachement []byte `json:"attachement"`
	Question Questions `json:"question"`
}