# frozen_string_literal: true

class ExpressionsController < ApplicationController
  before_action :set_expression, only: %i[show edit update destroy]
  before_action :require_login, only: %i[new create]
  before_action :require_authority, only: %i[edit update destroy]

  def show
    if @expression.user_id.nil?
      session.delete(:forwarding_url)
      session[:forwarding_url] = home_path
    elsif logged_in?
      redirect_to home_path, alert: t('.no_authority') if @expression.user_id != current_user.id
    else
      redirect_to root_path, alert: t('not_logged_in')
    end
  end

  def new; end

  def edit; end

  def create
    @expression = current_user.expressions.new(expression_params)
    @expression.tags = @expression.find_tags_object

    if @expression.save
      redirect_to expression_url(@expression), notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    params = expression_params
    @expression.destroy_taggings(params)
    @expression.destroy_expression_items(params)
    @expression.destroy_examples(params)
    remove_tag_params(params) if params[:tags_attributes]

    if @expression.update(params)
      redirect_to expression_url(@expression), notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    expression = @expression.next(current_user) || @expression.previous(current_user)
    path = unless expression
             if @expression.bookmarking?
               bookmarked_expressions_path
             elsif @expression.memorising?
               memorised_expressions_path
             else
               home_path
             end
           end

    @expression.destroy

    if expression
      redirect_to expression_path(expression), notice: t('.success')
    else
      redirect_to path, notice: t('.success')
    end
  end

  private

  def require_login
    return if logged_in?

    redirect_to root_path, alert: t('not_logged_in')
  end

  def require_authority
    if logged_in?
      redirect_to home_path, alert: t('no_authority') unless @expression.user_id == current_user.id
    else
      redirect_to root_path, alert: t('not_logged_in')
    end
  end

  def remove_tag_params(params)
    params[:tags_attributes].each do |parameter|
      tag = Tag.find_by name: parameter[1][:name]
      next unless tag

      Tagging.find_or_create_by!(tag:, expression: @expression)
      params[:tags_attributes].delete(parameter[0])
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_expression
    @expression = Expression.find(params[:id])
  end

  def expression_params
    params.require(:expression).permit(:id, :note, expression_items_attributes: [:id, :content, :explanation, { examples_attributes: %i[id content] }],
                                                   tags_attributes: %i[id name])
  end
end
