resource "aws_sqs_queue" "user_creation_dead_letter" {
	name = "${terraform.workspace}-user_creation_dead_letter"
	message_retention_seconds = 1209600
	tags = local.common_tags
}

resource "aws_sqs_queue" "user_creation_queue" {
	name = "${terraform.workspace}-asset-receive-user-creation-queue"
	redrive_policy = jsonencode({
		deadLetterTargetArn = aws_sqs_queue.user_creation_dead_letter.arn
		maxReceiveCount = 5
	})
	policy = jsonencode({
		"Version" : "2012-10-17"
		"Id" : "sqsPolicy"
		"Statement" : [{
			Sid : "First",
			Effect : "Allow",
			Principal : "*",
			Action : "sqs:*",
			Resource : "*",
			Condition : {
				"AreEquals" : {
					"aws:SourceArn" : var.configs.AWS_USER_TOPIC_ARN
					// aws_sns_topic.test.arn
				}
			}
		}]
	})

	tags = local.common_tags
	
}


resource "aws_sns_topic_subscription" "test_queue_subsc" {
	
	topic_arn = var.configs.AWS_USER_TOPIC_ARN
	//aws_sns_topic.test.arn
	protocol = "sqs"
	endpoint = aws_sqs_queue.user_creation_queue.arn
	raw_message_delivery = true
	filter_policy = "{\"event\": [\"ap_user_created\"]}"
}