package model

import "github.com/jinzhu/gorm"

type Answer struct {
	gorm.Model `swaggerignore:"true"`
	Answer string `json:"answer"`
	UserID uint `gorm:"TYPE:integer REFERENCES users"` //user que respondeu
	QuestionID uint `gorm:"TYPE:integer REFERENCES questions"`
	Attachement []byte `json:"attachement"`
}