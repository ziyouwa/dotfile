if [ "${XDG_SESSION_TYPE}" = "wayland" ]; then
	export GDK_BACKEND=wayland  # GDK
	export QT_QPA_PLATFORM=wayland  # QT
	export CLUTTER_BACKEND=wayland  # Clutter
	export SDL_VIDEODRIVER=wayland  # SDL
	export MOZ_ENABLE_WAYLAND=1
	# mozilla wayland envionment
	export MOZ_ENABLE_WAYLAND=1
fi

# export CARGO_HOME="$HOME/.cargo"
# export RUSTUP_HOME="$HOME/.rustup"
# export PATH=$HOME/.cargo/bin:$PATH:/opt/riscv64-lp64d-glibc-stable/bin
