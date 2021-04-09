package model

import (
	"time"

	"github.com/jinzhu/gorm"
)

type Appointment struct {
	gorm.Model `swaggerignore:"true"`
	ShowedUp   bool      `json:"showedUp"`
	AnimalID   uint      `gorm:"TYPE:integer REFERENCES animals"`
	Date       time.Time `json:"date"`
	VetID      uint      `gorm:"TYPE:integer REFERENCES users"`
	ReminderID uint      `gorm:"TYPE:integer REFERENCES reminders"`
}
