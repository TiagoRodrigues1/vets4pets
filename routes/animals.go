package routes

import (
	"projetoapi/controllers"
	"github.com/gin-gonic/gin"
)

func AddAnimal(c *gin.Context) {
	controllers.AddAnimal(c);
}



