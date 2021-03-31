package main

import (
	"projetoapi/model"
	"projetoapi/routes"
	"projetoapi/services"

	"github.com/gin-gonic/gin"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

var identityKey = "id"

func init() {
	services.OpenDatabase()
	services.Db.AutoMigrate(&model.Evaluation{})
	services.Db.AutoMigrate(&model.Users{})
	services.Db.AutoMigrate(&model.Animal{})
	services.Db.AutoMigrate(&model.Question{})
	services.Db.AutoMigrate(&model.Answer{})
	services.Db.AutoMigrate(&model.Appointment{})

	defer services.Db.Close()
}

func main() {

	services.FormatSwagger()

	// Creates a gin router with default middleware:
	// logger and recovery (crash-free) middleware
	router := gin.New()
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	// NO AUTH
	router.GET("/echo/:echo", routes.EchoRepeat)

	// AUTH
	router.NoRoute(func(c *gin.Context) {
		c.JSON(404, gin.H{"code": "PAGE_NOT_FOUND", "message": "Page not found"})
	})

	evaluation := router.Group("/api/v1/evaluation")
	evaluation.Use(services.AuthorizationRequired())
	{
		evaluation.POST("/", routes.AddEvaluation)
		evaluation.GET("/", routes.GetAllEvaluation)
		evaluation.GET("/:id", routes.GetEvaluationById)
		evaluation.PUT("/:id", routes.UpdateEvaluation)
		evaluation.DELETE("/:id", routes.DeleteEvaluation)
	}

	auth := router.Group("/api/v1/auth")
	{
		auth.POST("/login", routes.GenerateToken)
		auth.POST("/register", routes.RegisterUser)
		auth.PUT("/refresh_token", services.AuthorizationRequired(), routes.RefreshToken)
	}

	user := router.Group("api/v1/user")
	user.Use(services.AuthorizationRequired())
	{
		user.GET("/:id", routes.GetUserByID)
		user.PUT("/:id", routes.UpdateUser)
		user.GET("/:id/animals", routes.GetAnimalsFromUserID)
	}

	animal := router.Group("api/v1/animal")
	animal.Use(services.AuthorizationRequired())
	{
		animal.POST("/", routes.AddAnimal)
		animal.DELETE("/:id", routes.DeleteAnimal)
		animal.GET("/:id", routes.GetAnimalById)
		animal.PUT("/:id", routes.UpdateAnimal)
	}

	question := router.Group("api/v1/question")
	question.Use(services.AuthorizationRequired())
	{
		question.POST("/", routes.AddQuestion)
	}

	answer := router.Group("api/v1/answer")
	answer.Use(services.AuthorizationRequired())
	{
		answer.POST("/", routes.AddAnswer)
	}

	appointment := router.Group("api/v1/appointment")
	appointment.Use(services.AuthorizationRequired())
	{
		appointment.POST("/", routes.AddAppointment)
		appointment.PUT("/:id", routes.UpdateAppointment)
	}
	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	router.Run(":8080")
}
