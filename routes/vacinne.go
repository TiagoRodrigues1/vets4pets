package routes

import (
	"projetoapi/controllers"
	"github.com/gin-gonic/gin"
)


func AddVaccine(c *gin.Context) {
	controllers.AddVaccine(c)
}

func DeleteVaccine(c *gin.Context) {
	controllers.DeleteVaccine(c)
}

func GetVaccines(c *gin.Context) {
	controllers.GetVaccines(c)
}