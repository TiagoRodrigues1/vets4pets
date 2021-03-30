package routes

import (
	"projetoapi/controllers"
	"github.com/gin-gonic/gin"
)


func AddAnswer(c *gin.Context) {
	controllers.AddAnswer(c)
}