# frozen_string_literal: true

class ExpressionsController < ApplicationController
  before_action :set_expression, only: %i[show edit update destroy]

  # GET /expressions or /expressions.json
  def index
    @expressions = Expression.all
  end

  # GET /expressions/1 or /expressions/1.json
  def show; end

  # GET /expressions/new
  def new; end

  # GET /expressions/1/edit
  def edit; end

  # POST /expressions or /expressions.json
  def create
    @expression = Expression.new(expression_params)

    respond_to do |format|
      if @expression.save
        format.html { redirect_to expression_url(@expression), notice: 'Expression was successfully created.' }
        format.json { render :show, status: :created, location: @expression }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expression.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expressions/1 or /expressions/1.json
  def update
    respond_to do |format|
      if @expression.update(expression_params)
        format.html { redirect_to expression_url(@expression), notice: 'Expression was successfully updated.' }
        format.json { render :show, status: :ok, location: @expression }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expression.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expressions/1 or /expressions/1.json
  def destroy
    @expression.destroy

    respond_to do |format|
      format.html { redirect_to expressions_url, notice: 'Expression was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_expression
    @expression = Expression.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def expression_params
    params.require(:expression).permit(:note, expression_items_attributes: [:id, :content, :explanation, { examples_attributes: %i[id content] }])
  end
end
