package model

import (
	"time"
	"github.com/jinzhu/gorm"
)

type Reminder struct {
	gorm.Model `swaggerignore:"true"`
	AnimalID   uint      `gorm:"TYPE:integer REFERENCES animals"`
	Date       time.Time `json:"date"`
	Info       string    `json:"info"`
}
