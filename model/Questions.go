package model

import "github.com/jinzhu/gorm"

type Questions struct {
	gorm.Model `swaggerignore:"true"`
	Question string `json:"question"`
	UserID uint `gorm:"TYPE:integer REFERENCES users"` //quem fez a pergunta
	Answers []Answers `json:"answers"`
}