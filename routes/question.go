package routes

import (
	"projetoapi/controllers"
	"github.com/gin-gonic/gin"
)


func AddQuestion(c *gin.Context) {
	controllers.AddQuestion(c)
}