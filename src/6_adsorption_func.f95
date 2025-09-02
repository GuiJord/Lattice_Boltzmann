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

    subroutine adsorption()
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
    end subroutine adsorption

end module adsorption_mod