module propagation_mod
    use parameters
    use boundary_conditions_mod
    implicit none
    
contains

    
    
    !================================== Propagation - Beginning ============================================
    
    !f ==============================================
    subroutine propagation_f()
        f(:,:,9) = f_t(:,:,9)
        f(2:lx,:,1) = f_t(1:lx,:,1)
        f(:,2:ny,2) = f_t(:,1:ly,2)
        f(1:lx,:,3) = f_t(2:nx,:,3)
        f(:,1:ly,4) = f_t(:,2:ny,4)
        f(2:nx,2:ny,5) = f_t(1:lx,1:ly,5)
        f(1:lx,2:ny,6) = f_t(2:nx,1:ly,6)
        f(1:lx,1:ly,7) = f_t(2:nx,2:ny,7)
        f(2:nx,1:ly,8) = f_t(1:lx,2:ny,8)

        if ( log_load_geometry ) then
            call bounce_back_solids_f    
        end if
        call boundary_conditions_f
    end subroutine propagation_f
    !======================================== f - End
    
    !g ==============================================
    subroutine propagation_g()
        integer :: y
        g(:,:,9) = g_t(:,:,9)
        g(2:lx,:,1) = g_t(1:lx,:,1)
        g(:,2:ny,2) = g_t(:,1:ly,2)
        g(1:lx,:,3) = g_t(2:nx,:,3)
        g(:,1:ly,4) = g_t(:,2:ny,4)
        g(2:nx,2:ny,5) = g_t(1:lx,1:ly,5)
        g(1:lx,2:ny,6) = g_t(2:nx,1:ly,6)
        g(1:lx,1:ly,7) = g_t(2:nx,2:ny,7)
        g(2:nx,1:ly,8) = g_t(1:lx,2:ny,8)

        if ( log_load_geometry ) then
            call bounce_back_solids_g
            call bounce_back_frontier_g
            ! call bounce_back_ads_g
        end if
        call boundary_conditions_g
    end subroutine propagation_g
    !======================================== g - End
    
    !h ==============================================
    subroutine propagation_h()
        h(:,:,9) = h_t(:,:,9)
        h(2:lx,:,1) = h_t(1:lx,:,1)
        h(:,2:ny,2) = h_t(:,1:ly,2)
        h(1:lx,:,3) = h_t(2:nx,:,3)
        h(:,1:ly,4) = h_t(:,2:ny,4)
        h(2:nx,2:ny,5) = h_t(1:lx,1:ly,5)
        h(1:lx,2:ny,6) = h_t(2:nx,1:ly,6)
        h(1:lx,1:ly,7) = h_t(2:nx,2:ny,7)
        h(2:nx,1:ly,8) = h_t(1:lx,2:ny,8)

        if ( log_load_geometry ) then
            call bounce_back_solids_h    
        end if
        call boundary_conditions_h
    end subroutine propagation_h
    !======================================== h - End

    !================================== Propagation - End ==================================================
    
    

    !================================== Bounce Back - Beginning ============================================

    subroutine bounce_back_solids_f()
        integer :: i,x,y,dir,op_dir,xbb,ybb
        do i = 1, n_solid_points
            x = mask_x(i)
            y = mask_y(i)
            do dir = 1,8
                op_dir = op_directions(dir)
                xbb = x + dnint(ex(op_dir))
                ybb = y + dnint(ey(op_dir))
                if (xbb >= 1 .and. ybb >= 1 .and. xbb <= nx .and. ybb <= ny) then
                    if (lattice_mask(xbb,ybb) == 0 .or. lattice_mask(xbb,ybb) == 3) then 
                        f(xbb,ybb,op_dir) = f_t(xbb,ybb,dir)                        
                    end if
                end if
            end do
        end do
    end subroutine bounce_back_solids_f

    subroutine bounce_back_solids_g()
        integer :: i,x,y,dir,op_dir,xbb,ybb
        do i = 1, n_solid_points
            x = mask_x(i)
            y = mask_y(i)
            do dir = 1,8
                op_dir = op_directions(dir)
                xbb = x + dnint(ex(op_dir))
                ybb = y + dnint(ey(op_dir))
                if (xbb >= 1 .and. ybb >= 1 .and. xbb <= nx .and. ybb <= ny) then
                    if (lattice_mask(xbb,ybb) == 0 .or. lattice_mask(xbb,ybb) == 3) then 
                        g(xbb,ybb,op_dir) = g_t(xbb,ybb,dir)                        
                    end if
                end if
            end do
        end do
    end subroutine bounce_back_solids_g

    subroutine bounce_back_frontier_g()
        integer :: i,x,y,dir,op_dir,x_new,y_new
        do i = 1, n_ads_points_frontier
            x = mask_ads_frontier_x(i)
            y = mask_ads_frontier_y(i)
            do dir = 1,8
                op_dir = op_directions(dir)
                x_new = x + dnint(ex(dir))
                y_new = y + dnint(ey(dir))
                if (x_new >= 1 .and. y_new >= 1 .and. x_new <= nx .and. y_new <= ny) then
                    if (lattice_mask(x_new,y_new) == 2) then 
                        g(x,y,op_dir) = g_t(x,y,dir)
                        g(x_new,y_new,dir) = g_t(x_new,y_new,op_dir)
                    end if
                end if
            end do
        end do
    end subroutine bounce_back_frontier_g

    ! subroutine bounce_back_frontier_g()
    !     integer :: i,x,y,dir,op_dir,xbb,ybb
    !     do i = 1, n_ads_points_frontier
    !         x = mask_ads_frontier_x(i)
    !         y = mask_ads_frontier_y(i)
    !         do dir = 1,8
    !             op_dir = op_directions(dir)
    !             xbb = x + dnint(ex(op_dir))
    !             ybb = y + dnint(ey(op_dir))
    !             if (xbb >= 1 .and. ybb >= 1 .and. xbb <= nx .and. ybb <= ny) then
    !                 if (lattice_mask(xbb,ybb) == 2) then 
    !                     g(xbb,ybb,op_dir) = g_t(xbb,ybb,dir)                        
    !                 end if
    !             end if
    !         end do
    !     end do
    ! end subroutine bounce_back_frontier_g

        subroutine bounce_back_ads_g()
        integer :: i,x,y,dir,op_dir,xbb,ybb
        do i = 1, n_ads_points
            x = mask_ads_x(i)
            y = mask_ads_y(i)
            do dir = 1,8
                op_dir = op_directions(dir)
                xbb = x + dnint(ex(op_dir))
                ybb = y + dnint(ey(op_dir))
                if (xbb >= 1 .and. ybb >= 1 .and. xbb <= nx .and. ybb <= ny) then
                    if (lattice_mask(xbb,ybb) == 3) then 
                        g(xbb,ybb,op_dir) = g_t(xbb,ybb,dir)                        
                    end if
                end if
            end do
        end do
    end subroutine bounce_back_ads_g

    subroutine bounce_back_solids_h()
        integer :: i,x,y,dir,op_dir,xbb,ybb
        do i = 1, n_solid_points
            x = mask_x(i)
            y = mask_y(i)
            do dir = 1,8
                op_dir = op_directions(dir)
                xbb = x + dnint(ex(op_dir))
                ybb = y + dnint(ey(op_dir))
                if (xbb >= 1 .and. ybb >= 1 .and. xbb <= nx .and. ybb <= ny) then
                    if (lattice_mask(xbb,ybb) == 0 .or. lattice_mask(xbb,ybb) == 3) then 
                        h(xbb,ybb,op_dir) = h_t(xbb,ybb,dir)                        
                    end if
                end if
            end do
        end do
    end subroutine bounce_back_solids_h

    !================================== Bounce Back - End ==================================================

end module propagation_mod