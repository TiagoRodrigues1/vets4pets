package model

import (
	"time"

	"github.com/jinzhu/gorm"
)

type Prescription struct {
	gorm.Model `swaggerignore:"true"`
	Medication string      `json:"medication"`
	Date       []time.Time `json:"date"`
	AnimalID   uint        `gorm:"TYPE:integer REFERENCES animals"`
	ReminderID uint        `gorm:"TYPE:integer REFERENCES reminders"`
}
