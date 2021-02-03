class BookCommentsController < ApplicationController
  before_action :correct_ensure_user, only: [:destroy]

  def create
    @book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    @comment.book_id = @book.id
    if @comment.save
      redirect_to book_path(@book)
    else
      @book_new = Book.new
      render 'books/show'
    end
  end

  def destroy
    BookComment.find_by(id: params[:id], book_id: params[:book_id]).destroy
    redirect_to book_path(params[:book_id])
  end

  private
    def book_comment_params
      params.require(:book_comment).permit(:comment)
    end

    def correct_ensure_user
      @comment = BookComment.find(params[:id])
      unless @comment.user == current_user
        redirect_to current_user
      end
    end
end
