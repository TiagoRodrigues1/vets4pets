package model

import (
	"time"

	"github.com/jinzhu/gorm"
)

type Calendar struct {
	gorm.Model `swaggerignore:"true"`
	AnimalID   uint      `gorm:"TYPE:integer REFERENCES animals"`
	Date       time.Time `json:"date"`
}
