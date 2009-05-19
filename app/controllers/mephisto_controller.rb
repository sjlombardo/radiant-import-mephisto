class MephistoController < ActionController::Base
  
  def redirect
    redirect_to url_for("/blog/#{params[:year]}/#{sprintf("%02d",params[:month].to_i)}/#{sprintf("%02d",params[:day].to_i)}/#{params[:slug]}/"), :status=>:moved_permanently
  end
  
end  
