  
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
	Weight     float64   `json:"weight"`	
	Price     float64   `json:"price"`
	ClinicID   uint		 `gorm:"TYPE:integer REFERENCES clinics"`	
	VetID      uint      `gorm:"TYPE:integer REFERENCES users"`				//Id do veterinario
	ReminderID uint      `gorm:"TYPE:integer REFERENCES reminders"`			//Notificação sobre a consulta
}
