package routes

import (
	"projetoapi/controllers"
	"github.com/gin-gonic/gin"
)

func GetUserByID(c *gin.Context) {
	controllers.GetUserByID(c);
	//log.Println(c);
	//fmt.Println(c);
}
