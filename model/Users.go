package model

import (
	"time"
	"github.com/jinzhu/gorm"
)

type Users struct {
	gorm.Model `swaggerignore:"true"`
	Username   string `json:"username"`
	Password   string `json:"password"`
	Email	   string `json:"email"`
	Name	   string `json:"name"`
	UserType   string `json:"userType"`
	Contact	   string `json:"contact"`
	ClinicID   int    `json:"idclinic"`
	Gender 	   bool   `json:"gender"`
	Birthday  time.Time `json:"birthday"`
	ProfilePicture string `json:"profilePicture"`
	NumberOfAnsweredQuestions int `json:"numberOfAnsweredQuestions"`
}

