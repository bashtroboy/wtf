class HistoryController < ApplicationController

    def index
        @queries = Query.all
    end
    
end
