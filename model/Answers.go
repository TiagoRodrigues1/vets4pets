package model

//import "github.com/jinzhu/gorm"

type Answers struct {
	Answer string `json:"answer"`
	UserAnswered Users `json:"userAnswered"`
	Question Questions `json:"question"`
}