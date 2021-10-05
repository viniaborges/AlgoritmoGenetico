function result=plotRoute(route)
    plot(route(:,2),route(:,3))
    hold;
    plot(route(:,2),route(:,3),'o','MarkerSize',3,'MarkerEdgeColor','k','MarkerFaceColor','r');
end