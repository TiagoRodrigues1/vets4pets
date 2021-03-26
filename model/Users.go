package model

import "github.com/jinzhu/gorm"

type Users struct {
	gorm.Model `swaggerignore:"true"`
	Username   string `json:"username"`
	Password   string `json:"password"`
	Email	   string `json:"email"`
	Name	   string `json:"name"`
	UserType   string `json:"userType"`
	Contact	   string `json:"contact"`
	NumberOfAnsweredQuestions string `json:"numberOfAnsweredQuestions"`
}
