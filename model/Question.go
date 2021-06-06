package model

import "github.com/jinzhu/gorm"

type Question struct {
	gorm.Model `swaggerignore:"true"`
	QuestionTitle string `json:"questiontitle"`
	Question string `json:"question"`
	UserID uint `gorm:"TYPE:integer REFERENCES users"` //quem fez a pergunta
	Answers int `json:"answers"`
	Attachement string `json:"attachement"`
	Closed bool `json:"closed"`
	Username string `json:"username"`
}