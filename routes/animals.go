package routes

import (
	"projetoapi/controllers"
	"github.com/gin-gonic/gin"
)

func AddAnimal(c *gin.Context) {
	controllers.AddAnimal(c)
}

func DeleteAnimal(c *gin.Context) {
	controllers.DeleteAnimal(c)
}

func GetAnimalById(c *gin.Context) {
	controllers.GetAnimalById(c)
}

func UpdateAnimal(c *gin.Context) {
	controllers.UpdateAnimal(c)
}