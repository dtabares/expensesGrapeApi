require_relative '../config/app.rb'

module Expenses
  class ExpensesAPI < Grape::API
    version 'v1', :using => :path
    format :json

    get '/expenses' do
      @expenses = Expense.all(:deleted => false)
      @expenses
    end

    post "/expenses/new" do
        begin
          params.merge! JSON.parse(request.env["rack.input"].read)
        rescue JSON::ParserError
          logger.error "Cannot parse request body."
        end
        @expense = Expense.new
        @expense.date = DateTime.parse(params[:date])
        @expense.type = params[:type]
        @expense.subtype = params[:subtype]
        @expense.description = params[:description]
        @expense.value = params[:value]
        @expense.deleted = false
        if @expense.save
            @expenses = Expense.all(:deleted => false)
            {:expenses => @expenses, :status => "success"}
        else
            status 500
            body @expense.save
        end

    end

    put "/expense/edit" do
        begin
          params.merge! JSON.parse(request.env["rack.input"].read)
        rescue JSON::ParserError
          logger.error "Cannot parse request body."
        end
        @expense = Expense.get(params[:id])
        @expense.date = DateTime.parse(params[:date])
        @expense.type = params[:type]
        @expense.subtype = params[:subtype]
        @expense.description = params[:description]
        @expense.value = params[:value]
        if @expense.save
            @expenses = Expense.all(:deleted => false)
            {:expenses => @expenses, :status => "success"}
        else
            status 500
            body @expense.save
        end
    end

    put "/expense/delete" do
        begin
          params.merge! JSON.parse(request.env["rack.input"].read)
        rescue JSON::ParserError
          logger.error "Cannot parse request body."
        end
        @expense = Expense.get(params[:id])
        @expense.deleted = true
        if @expense.save
            @expenses = Expense.all(:deleted => false)
            {:expenses => @expenses, :status => "success"}
        else
            status 500
            body @expense.save
        end
    end

  end
end
