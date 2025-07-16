module adsorption_mod
    use parameters
    implicit none

contains

    subroutine reaction(C_,C_a_,r)
        real*8, intent(in) :: C_,C_a_
        real*8, intent(out) ::  r

        !Henry
        r = k_D*C_a_ - k_A*C_

        !Langmuir
        ! r = k_D*C_a_ - k_A*(C_-C_a_)
    end subroutine reaction

    subroutine adsorption_old()
        integer :: i,x,y
        real*8:: C_,C_a_
        real*8 ::  r

        do x = 1,nx
        call reaction(C(x,2),C(x,1),r)
        C_ = C(x,2) + r
        C_a_ = C(x,1) - r

        g_t(x,2,9) = w(9)*C_
        g_t(x,2,1) = w(1)*C_
        g_t(x,2,2) = w(2)*C_
        g_t(x,2,3) = w(3)*C_
        g_t(x,2,4) = w(4)*C_
        g_t(x,2,5) = w(5)*C_
        g_t(x,2,6) = w(6)*C_
        g_t(x,2,7) = w(7)*C_
        g_t(x,2,8) = w(8)*C_

        g_t(x,1,9) = w(9)*C_a_
        g_t(x,1,1) = w(1)*C_a_
        g_t(x,1,2) = w(2)*C_a_
        g_t(x,1,3) = w(3)*C_a_
        g_t(x,1,4) = w(4)*C_a_
        g_t(x,1,5) = w(5)*C_a_
        g_t(x,1,6) = w(6)*C_a_
        g_t(x,1,7) = w(7)*C_a_
        g_t(x,1,8) = w(8)*C_a_

        call reaction(C(x,ny-1),C(x,ny),r)
        C_ = C(x,ny-1) + r
        C_a_ = C(x,ny) - r

        g_t(x,ny-1,9) = w(9)*C_
        g_t(x,ny-1,1) = w(1)*C_
        g_t(x,ny-1,2) = w(2)*C_
        g_t(x,ny-1,3) = w(3)*C_
        g_t(x,ny-1,4) = w(4)*C_
        g_t(x,ny-1,5) = w(5)*C_
        g_t(x,ny-1,6) = w(6)*C_
        g_t(x,ny-1,7) = w(7)*C_
        g_t(x,ny-1,8) = w(8)*C_

        g_t(x,ny,9) = w(9)*C_a_
        g_t(x,ny,1) = w(1)*C_a_
        g_t(x,ny,2) = w(2)*C_a_
        g_t(x,ny,3) = w(3)*C_a_
        g_t(x,ny,4) = w(4)*C_a_
        g_t(x,ny,5) = w(5)*C_a_
        g_t(x,ny,6) = w(6)*C_a_
        g_t(x,ny,7) = w(7)*C_a_
        g_t(x,ny,8) = w(8)*C_a_
        end do
    end subroutine adsorption_old

    subroutine adsorption_new_new()
        integer :: i,x,y
        integer :: x_new, y_new, dir, op_dir
        real*8 :: r, n_neighb_ads

        do i = 1,n_ads_points_frontier
            x = mask_ads_frontier_x(i)
            y = mask_ads_frontier_y(i)
            n_neighb_ads = num_neighb_ads_list(i)

            do dir = 1,8
                op_dir = op_directions(dir)
                x_new = x + int(ex(dir))
                y_new = y + int(ey(dir))
                if (x_new >= 1 .and. y_new >= 1 .and. x_new <= nx .and. y_new <= ny) then
                    if (lattice_mask(x_new,y_new) == 2) then 
                        call reaction(C(x,y),C(x_new,y_new),r)
                        g_t(x,y,dir) = g_t(x,y,dir) + r/n_neighb_ads
                        g_t(x_new,y_new,op_dir) = g_t(x_new,y_new,op_dir) - r/n_neighb_ads
                    end if
                end if
            end do
        end do
    end subroutine adsorption_new_new

    subroutine adsorption_new()
        integer :: i,x,y
        integer :: xbb, ybb, op_dir, dir
        real*8 :: r 
    
        do i = 1,n_ads_points_frontier
            x = mask_ads_frontier_x(i)
            y = mask_ads_frontier_y(i)
            do dir = 1,8
                op_dir = op_directions(dir)
                xbb = x + dnint(ex(op_dir))
                ybb = y + dnint(ey(op_dir))
                if (xbb >= 1 .and. ybb >= 1 .and. xbb <= nx .and. ybb <= ny) then
                    if (lattice_mask(xbb,ybb) == 2) then 
                        call reaction(C(x,y),C(xbb,ybb),r)
                        g_t(x,y,dir) = g_t(x,y,dir) + r
                        g_t(xbb,ybb,op_dir) = g_t(xbb,ybb,op_dir) - r
                    end if
                end if
            end do
        end do
    end subroutine adsorption_new

    subroutine adsorption()
        integer :: i,x,y
        integer :: xbb, ybb, op_dir, dir
        real*8 :: r
        
        do i = 1,n_ads_points_frontier
            x = mask_ads_frontier_x(i)
            y = mask_ads_frontier_y(i)
            do dir = 1,4
                xbb = x + dnint(ex(dir))
                ybb = y + dnint(ey(dir))
                if (xbb >= 1 .and. ybb >= 1 .and. xbb <= nx .and. ybb <= ny) then
                    if (lattice_mask(xbb,ybb) == 2) then 
                        call reaction(C(x,y),C(xbb,ybb),r)
                        C(x,y) = C(x,y) + r
                        C(xbb,ybb) = C(xbb,ybb) - r
                        
                        !AN OPTIMIZATION IS TO USE AUXILIARY VARIABLES FOR C AND C_A 
                        g_t(x,y,9) = w(9)*C(x,y)
                        g_t(x,y,1) = w(1)*C(x,y)
                        g_t(x,y,2) = w(2)*C(x,y)
                        g_t(x,y,3) = w(3)*C(x,y)
                        g_t(x,y,4) = w(4)*C(x,y)
                        g_t(x,y,5) = w(5)*C(x,y)
                        g_t(x,y,6) = w(6)*C(x,y)
                        g_t(x,y,7) = w(7)*C(x,y)
                        g_t(x,y,8) = w(8)*C(x,y)

                        g_t(xbb,ybb,9) = w(9)*C(xbb,ybb)
                        g_t(xbb,ybb,1) = w(1)*C(xbb,ybb)
                        g_t(xbb,ybb,2) = w(2)*C(xbb,ybb)
                        g_t(xbb,ybb,3) = w(3)*C(xbb,ybb)
                        g_t(xbb,ybb,4) = w(4)*C(xbb,ybb)
                        g_t(xbb,ybb,5) = w(5)*C(xbb,ybb)
                        g_t(xbb,ybb,6) = w(6)*C(xbb,ybb)
                        g_t(xbb,ybb,7) = w(7)*C(xbb,ybb)
                        g_t(xbb,ybb,8) = w(8)*C(xbb,ybb)
                    end if
                end if

            end do
        end do

        ! do x = 1, nx

        !     y = ny/2+1
        !     call reaction(C(x,y),C(x,y-1),r)

        !     C(x,y) = C(x,y) + r
        !     C(x,y-1) = C(x,y-1) - r

        !     g_t(x,y,9) = w(9)*C(x,y)
        !     g_t(x,y,1) = w(1)*C(x,y)
        !     g_t(x,y,2) = w(2)*C(x,y)
        !     g_t(x,y,3) = w(3)*C(x,y)
        !     g_t(x,y,4) = w(4)*C(x,y)
        !     g_t(x,y,5) = w(5)*C(x,y)
        !     g_t(x,y,6) = w(6)*C(x,y)
        !     g_t(x,y,7) = w(7)*C(x,y)
        !     g_t(x,y,8) = w(8)*C(x,y)

        !     g_t(x,y-1,9) = w(9)*C(x,y-1)
        !     g_t(x,y-1,1) = w(1)*C(x,y-1)
        !     g_t(x,y-1,2) = w(2)*C(x,y-1)
        !     g_t(x,y-1,3) = w(3)*C(x,y-1)
        !     g_t(x,y-1,4) = w(4)*C(x,y-1)
        !     g_t(x,y-1,5) = w(5)*C(x,y-1)
        !     g_t(x,y-1,6) = w(6)*C(x,y-1)
        !     g_t(x,y-1,7) = w(7)*C(x,y-1)
        !     g_t(x,y-1,8) = w(8)*C(x,y-1)

            ! y = ny-5
            ! call reaction(C(x,y),C(x,y+1),r)
            ! C(x,y) = C(x,y) + r
            ! C(x,y+1) = C(x,y+1) - r


            ! g_t(x,y,9) = w(9)*C(x,y)
            ! g_t(x,y,1) = w(1)*C(x,y)
            ! g_t(x,y,2) = w(2)*C(x,y)
            ! g_t(x,y,3) = w(3)*C(x,y)
            ! g_t(x,y,4) = w(4)*C(x,y)
            ! g_t(x,y,5) = w(5)*C(x,y)
            ! g_t(x,y,6) = w(6)*C(x,y)
            ! g_t(x,y,7) = w(7)*C(x,y)
            ! g_t(x,y,8) = w(8)*C(x,y)

            ! g_t(x,y+1,9) = w(9)*C(x,y+1)
            ! g_t(x,y+1,1) = w(1)*C(x,y+1)
            ! g_t(x,y+1,2) = w(2)*C(x,y+1)
            ! g_t(x,y+1,3) = w(3)*C(x,y+1)
            ! g_t(x,y+1,4) = w(4)*C(x,y+1)
            ! g_t(x,y+1,5) = w(5)*C(x,y+1)
            ! g_t(x,y+1,6) = w(6)*C(x,y+1)
            ! g_t(x,y+1,7) = w(7)*C(x,y+1)
            ! g_t(x,y+1,8) = w(8)*C(x,y+1)
        !end do
    end subroutine adsorption

    ! subroutine adsorption()
    !     integer :: i,x,y
    !     real*8 :: r
        
    !     do i = 1,n_ads_points_frontier
    !         x = mask_ads_frontier_x(i)
    !         y = mask_ads_frontier_y(i)

    !         call reaction(C(x,y),C(x,y-1), r)

    !         C(x,y) = C(x,y) + r
    !         C(x,y-1) = C(x,y-1) - r

    !         print*, C(x,y), C(x,y-1), r

    !         g_t(x,y,9) = w(9)*C(x,y)
    !         g_t(x,y,1) = w(1)*C(x,y)
    !         g_t(x,y,2) = w(2)*C(x,y)
    !         g_t(x,y,3) = w(3)*C(x,y)
    !         g_t(x,y,4) = w(4)*C(x,y)
    !         g_t(x,y,5) = w(5)*C(x,y)
    !         g_t(x,y,6) = w(6)*C(x,y)
    !         g_t(x,y,7) = w(7)*C(x,y)
    !         g_t(x,y,8) = w(8)*C(x,y)

    !         g_t(x,y-1,9) = w(9)*C(x,y-1)
    !         g_t(x,y-1,1) = w(1)*C(x,y-1)
    !         g_t(x,y-1,2) = w(2)*C(x,y-1)
    !         g_t(x,y-1,3) = w(3)*C(x,y-1)
    !         g_t(x,y-1,4) = w(4)*C(x,y-1)
    !         g_t(x,y-1,5) = w(5)*C(x,y-1)
    !         g_t(x,y-1,6) = w(6)*C(x,y-1)
    !         g_t(x,y-1,7) = w(7)*C(x,y-1)
    !         g_t(x,y-1,8) = w(8)*C(x,y-1)
    !     end do  
    ! end subroutine adsorption

    ! subroutine adsorption()
    !     real*8 :: sum_g_ads,sum_g_f
    !     real*8 :: gamma, gamma_bar
    !     real*8 :: C_,r
    !     integer :: tx,ty,dir
    !     integer :: i,x,y

    !     tx = 0
    !     ty = 1

    !     sum_g_ads = 0
    !     sum_g_f = 0
    !     do i = 1,n_ads_points_frontier
    !         x = mask_ads_frontier_x(i)
    !         y = mask_ads_frontier_y(i)
    !         do dir = 1,9
    !             if ( tx*ex(dir) + ty*ey(dir) >= 0 ) then
    !                 sum_g_f = sum_g_f + g(x,y,dir)
    !             end if
    !         end do
    !         C_ = C(x,y)
    !         sum_g_ads = C_ - sum_g_f
    !         call reaction(C_,C_a(x-tx,y-ty),r)

    !         gamma = r/sum_g_ads
    !         gamma_bar = (C_-r)/sum_g_f

    !         do dir = 1,9
    !             if ( tx*ex(dir) + ty*ey(dir) < 0 ) then
    !                 g(x,y,dir) = gamma*g(x,y,dir)
    !             else
    !                 g(x,y,dir) = gamma_bar*g(x,y,dir)
    !             end if
    !         end do
    !     end do
    ! end subroutine adsorption



    ! subroutine adsorption_diff()
    !     real*8 :: sum_g_ads,sum_g_f,sum_r
    !     real*8 :: gamma, gamma_bar
    !     real*8 :: C_,r
    !     integer :: tx,ty,dir
    !     integer :: i,x,y

    !     sum_g_ads = 0
    !     sum_g_f = 0
    !     do i = 1,n_ads_points_frontier
    !         x = mask_ads_frontier_x(i)
    !         y = mask_ads_frontier_y(i)
    !         do dir = 1,9
    !             if ( tx*ex(dir) + ty*ey(dir) >= 0 ) then
    !                 sum_g_f = sum_g_f + g(x,y,dir)
    !             end if
    !         end do
    !         C_ = C(x,y)
    !         sum_g_ads = C_ - sum_g_f
            
    !         sum_r = 0
    !         do dir = 1,9
    !             if ( tx*ex(dir) + ty*ey(dir) < 0 ) then
    !                 call reaction(C_,C_a(x-int(ex(dir)),y-int(ey(dir))),r)        
    !             end if
    !             gamma = r/sum_g_ads
    !             g(x,y,dir) = gamma*g(x,y,dir)
    !             sum_r = sum_r + g(x,y,dir)
    !         end do

    !         gamma_bar = (C_-sum_r)/sum_g_f

    !         do dir = 1,9
    !             if ( tx*ex(dir) + ty*ey(dir) >= 0 ) then
    !                 g(x,y,dir) = gamma_bar*g(x,y,dir)
    !             end if
    !         end do
    !     end do
    ! end subroutine adsorption_diff



end module adsorption_mod