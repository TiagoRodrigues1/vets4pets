  
package model

import (
	

	"github.com/jinzhu/gorm"
)
type Clinic struct {
	gorm.Model `swaggerignore:"true"`
	Name       string `json:"name"`
	Contact    string `json:"contact"`
	Email      string `json:"email"`
	Address    string `json:"address"`
	UserID uint `gorm:"TYPE:integer REFERENCES users"` //quem fez a pergunta
	Latitude   string `json:"latitude"`
	Longitude  string `json:"longitude"`

}
