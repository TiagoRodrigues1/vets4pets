package routes

import (
	"projetoapi/controllers"
	"github.com/gin-gonic/gin"
)


func AddAdoption(c *gin.Context) {
	controllers.AddAdoption(c)
}

func DeleteAdoption(c *gin.Context) {
	controllers.DeleteAdoption(c)
}

func GetAdoptionsByUser(c *gin.Context) {
	controllers.GetAdoptionsByUser(c)
}

func GetAdoptionsByTime(c *gin.Context) {
	controllers.GetAdoptionsByTime(c)
}

func UpdateAdoption(c *gin.Context) {
	controllers.UpdateAdoption(c)
}


