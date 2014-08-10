git filter-branch --env-filter '
    if [ "$GIT_AUTHOR_NAME" = "robj" ]; then \
	        export GIT_AUTHOR_NAME="r" GIT_AUTHOR_EMAIL="r@example.com"; \
			    fi
				    '
