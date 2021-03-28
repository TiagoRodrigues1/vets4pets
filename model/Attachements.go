package model

import "github.com/jinzhu/gorm"

type Attachements struct {
	gorm.Model `swaggerignore:"true"`
	Attachement []byte `json:"attachement"`
	QuestionID uint `gorm:"TYPE:integer REFERENCES questions"`
}