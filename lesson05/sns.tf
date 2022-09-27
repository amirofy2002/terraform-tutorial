resource "aws_sns_topic" "test" {
	name = "${terraform.workspace}-test-local-topic"
	tags = local.common_tags
}

data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "sns_topic_policy"{
	policy_id = "${aws_sns_topic.test.name}_default_policy_id"
	statement {
		actions = [
			"SNS:Subscribe",
			"SNS:SetTopicAttributes",
			"SNS:RemovePermission",
			"SNS:Receive",
			"SNS:Publish",
			"SNS:ListSubscriptionsByTopic",
			"SNS:GetTopicAttributes",
			"SNS:DeleteTopic",
			"SNS:AddPermission"	
	]


	condition {
		test = "StringEquals"
		variable = "AWS:SourceOwner"

		values = [
			data.aws_caller_identity.current.account_id
		]
	}

	effect = "Allow"

	principals {
		type = "AWS"
		identifiers = ["*"]
	}

	resources = [
		"*"
	]
	
	sid = "${aws_sns_topic.test.name}_default_statement_id"

	}

	

	
}



resource "aws_sns_topic_policy" "default" {
	arn = aws_sns_topic.test.arn
	policy = data.aws_iam_policy_document.sns_topic_policy.json

}
