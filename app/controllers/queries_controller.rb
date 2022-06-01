
require 'google/cloud/language'
require 'json'

class QueriesController < ApplicationController
    def show
        @query = Query.find(params[:id])
    end

    def index
        @queries = Query.all
        @query = Query.new 
    end

    def create
        key_file = Hash.new

        # Insert details from service account JSON key, stored as secrets
        key_file["type"] = ""
        key_file["project_id"] =  ""
        key_file["private_key_id"] =  ""
        key_file["private_key"] =  ""
        key_file["client_email"] =  ""
        key_file["client_id"] =  ""
        key_file["auth_uri"] = ""
        key_file["token_uri"] =  ""
        key_file["auth_provider_x509_cert_url"] =  ""
        key_file["client_x509_cert_url"] =  ""

        client = Google::Cloud::Language.language_service do |config|
            config.credentials = key_file
        end
        
        doc = Google::Cloud::Language::V1::Document.new content: q_params['content'], type: 1             # language: if not specified, automatically detected
        sentiment_request = Google::Cloud::Language::V1::AnalyzeSentimentRequest.new document: doc
        entities_request = Google::Cloud::Language::V1::AnalyzeEntitiesRequest.new document: doc
        syntax_request = Google::Cloud::Language::V1::AnalyzeSyntaxRequest.new document: doc
=begin
        annotation_features  = Google::Cloud::Language::V1::AnnotateTextRequest::Features.new 
        annotation_features.extract_syntax = true
        annotation_features.extract_entities = true
        annotation_features.extract_document_sentiment = true
        annotation_features.extract_entity_sentiment = true
        annotation_features.classify_text = true
        
        annotation_request = Google::Cloud::Language::V1::AnnotateTextRequest.new document: doc, features: annotation_features
=end
        raw_sentiment_response = client.analyze_sentiment sentiment_request
        raw_entities_response = client.analyze_entities entities_request
        raw_syntax_response = client.analyze_syntax syntax_request

        #annotation_response = client.annotate_text annotation_request

        @query = Query.new({"content"=>q_params["content"], 
            "sentiment_language" => raw_sentiment_response.language,
            "sentiment_score" => raw_sentiment_response.document_sentiment.score,
            "sentiment_magnitude" => raw_sentiment_response.document_sentiment.magnitude,
            "sentiment_raw" => raw_sentiment_response,
            "entities_raw" => raw_entities_response,
            "syntax_raw" => raw_syntax_response
            })
        
        respond_to do |format|
            if @query.save
                format.html {redirect_to @query, notice: 'Query was added' }
                format.js
                format.json { render json: @query, status: :created, location: @user }
            else
                format.html { render action: "new" }
                format.json { render json: @query.errors, status: :unprocessable_entity }
            end
        end
    end

    private
    def q_params
        params.require(:query).permit(:content, :sentiment)
    end
end
