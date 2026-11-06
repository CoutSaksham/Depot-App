module StoreIndexVisitCount
  private def get_counter
    session[:store_index_visit_counter] ||= -1
  end

  private def update_counter
    session[:store_index_visit_counter] = get_counter
    session[:store_index_visit_counter] += 1
  end

  private def reset_counter
    session[:store_index_visit_counter] = get_counter
    session[:store_index_visit_counter] = -1
  end
end
